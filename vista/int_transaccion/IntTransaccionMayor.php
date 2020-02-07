<?php
/**
*@package pXP
*@file gen-IntTransaccionMayor.php
*@author  (admin)
*@date 01-09-2013 18:10:12
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
********************************************************************************
HISTORIAL DE MODIFICACIONES:
ISSUE 		   FECHA   			     AUTOR				 DESCRIPCION:
#17 		09/01/2019		        Manuel Guerra	  agrego el filtro de nro_tramite_aux
#20         10/01/2019 ENDETRAS     Miguel Mamani     Ocultar botón para exportar datos de grilla
#22         14/01/2019 ENDETRAS     Miguel Mamamni    Mostrar boton para exportar datos de grilla
#91         15/01/2020 ENDETR       JUAN              Libro mayor añadir columna beneficiario
#102        6/2/2020          Manuel Guerra     agregar campo nro_tramite_auxiliar, en vista del mayor
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
var ini=null;
var fin=null;
var id_auxiliar=null;
var id_centro_costo;
var id_config_subtipo_cuenta=null;
var id_config_tipo_cuenta=null;
var id_cuenta=null;
var id_depto=null;
var id_gestion=null;
var id_orden_trabajo=null;
var id_partida=null;
var id_suborden=null;
var id_tipo_cc=null;
var nro_tramite=null;
var tipo_filtro=null;
var fec=null;

Phx.vista.IntTransaccionMayor=Ext.extend(Phx.gridInterfaz,{
    title:'Mayor',
	constructor:function(config){		
		var me = this;
		console.log('?',me);
		this.maestro=config.maestro;
		 //Agrega combo de moneda
		
		this.Atributos = [
			{
				//configuracion del componente
				config:{
						labelSeparator:'',
						inputType:'hidden',
						name: 'id_int_transaccion'
				},
				type:'Field',
				form:true 
			},
			{
				//configuracion del componente
				config:{
					  fieldLabel:'ID Cbte',
					  	labelSeparator:'',
						inputType:'hidden',
						name: 'id_int_comprobante',
						gwidth:60,
				},
				type:'Field',
				grid:true,
				form:true 
			},
			{
	   			config:{
	   				sysorigen:'sis_contabilidad',
	       		    name:'id_cuenta',
	   				origen:'CUENTA',
	   				allowBlank:false,
	   				fieldLabel:'Cuenta',
	   				gdisplayField:'desc_cuenta',//mapea al store del grid
	   				gwidth:500,
	   				width: 350,
	   				listWidth: 350,
	   				scope: this,
		   			renderer:function (value, p, record){
		   			    var color = 'green';
		   			    if(record.data["tipo_reg"] != 'summary'){
			   			    if(record.data["tipo_partida"] == 'flujo'){
			   			        color = 'red';
			   			    }
			   			    
			   					/*
			   				var retorno =  String.format('<b>CC:</b> {0}, <br><b>Ptda.:</b> <font color="{1}">{2}</font><br><b>Cta.:</b>{3}<br><b>Aux.:</b>{4}',record.data['desc_centro_costo'],color, record.data['desc_partida'],
			   					                   record.data['desc_cuenta'],record.data['desc_auxiliar']);	
			   					
				   				
				   				if(record.data['desc_orden']){
				   					retorno = retorno + '<br><b>Ord.:</b> '+record.data['desc_orden'];
				   				}
				   				if(record.data['desc_suborden']){
				   					retorno = retorno + '<br><b>Sub.:</b> '+record.data['desc_suborden'];
				   				}	
			   				return retorno;	*/
			   				
			   				var retorno =  String.format('<b>CC:</b> {0}, <br><b>Cta.:</b>{1}<br>',record.data['desc_centro_costo'], record.data['desc_cuenta']);	
		   					if(record.data['desc_auxiliar']){
			   					retorno = retorno + String.format('<b>Aux.:</b> {0}</br>', record.data['desc_auxiliar']);
			   				}
		   					if(record.data['desc_partida']){
			   					retorno = retorno + String.format('<b>Ptda.:</b> <font color="{0}">{1}</font><br>',color, record.data['desc_partida']);
			   				}
		   					if(record.data['desc_orden']){			   					
			   					retorno = retorno + String.format('<b>Ord.:</b> <font> {0} {1}</font><br>', record.data['codigo_ot'], record.data['desc_orden']);
			   				}	
			   				if(record.data['desc_suborden']){
			   					retorno = retorno + '<b>Sub.:</b> '+record.data['desc_suborden'];
			   				}
		   				    return String.format('<div class="gridmultiline">{0}</div>',retorno);
			   				
			   				
		   			    	
		   			    }
		   			    else{
		   			    	//cargar resumen en el panel
		   			    	var debe = record.data["importe_debe_mb"]?record.data["importe_debe_mb"]:0,
		   			    		haber = record.data["importe_haber_mb"]?record.data["importe_haber_mb"]:0,
		   			    		sum_debe,
		   			    		sum_haber,
		   			    		sum_saldo_mb_d=0,
		   			    		sum_saldo_mb_h=0;	
		   			    	///		   			    		
		   			    	var saldo_mb = record.data["saldo_mb"]?record.data["saldo_mb"]:0;
								   			    	
		   			    	if(saldo_mb>0){
		   			    		sum_saldo_mb_d=saldo_mb;
		   			    		sum_saldo_mb_h=0;
		   			    	}else{
		   			    		sum_saldo_mb_d=0;
		   			    		sum_saldo_mb_h=saldo_mb;
		   			    	}			
		   			    	///				
		   			    	if ((debe - haber ) > 0) {
		   			    		sum_debe = debe - haber;
		   			    		sum_haber = '';		
		   			    	}
		   			    	else{
		   			    		sum_debe = '';
		   			    		sum_haber = haber - debe;	   			    		
		   			    	}
		   			    	///saldos
		   			    	var t=0;
		   			    	sum_saldo_mb_d=sum_debe + parseFloat(sum_saldo_mb_d,2);
		   			    	sum_saldo_mb_h=sum_haber + parseFloat(sum_saldo_mb_h,2);
		   			    	sum_saldo_mb_h=saldo_mb;
							//08/10/2018 manuel guerra
							//muestra los resultados con saldos
							//verifica los datos del saldo anterior, con el rango de fechas
							sum_saldo_mb_d=saldo_mb;
							sum_saldo_mb_h=debe-haber;
							 
							if(sum_saldo_mb_d>=0){
		   			    		if(sum_saldo_mb_h>=0){
		   			    			t=parseFloat(sum_saldo_mb_d,2)+parseFloat(sum_saldo_mb_h,2);
		   			    		}else{		   			    			
		   			    			t=parseFloat(sum_saldo_mb_d,2)+parseFloat(sum_saldo_mb_h,2);		   			    		
		   			    		}
		   			    	}else{
		   			    		if(sum_saldo_mb_h>=0){
		   			    			t=parseFloat(sum_saldo_mb_d,2)+parseFloat(sum_saldo_mb_h,2);
		   			    			console.log('===',sum_saldo_mb_d,'-',sum_saldo_mb_h);
		   			    			console.log('total->',sum_saldo_mb_d-sum_saldo_mb_h);
		   			    		}else{
		   			    			t=parseFloat(sum_saldo_mb_d,2)+parseFloat(sum_saldo_mb_h,2);
		   			    		}
		   			    	}
		   			    	//coloca en debe o haber
		   			    	if(t>0){
		   			    		sum_saldo_mb_d=parseFloat(t,2);
		   			    		sum_saldo_mb_h='';	
		   			    	}else{
		   			    		sum_saldo_mb_d='';
		   			    		sum_saldo_mb_h=parseFloat(t*-1,2);
		   			    	}
		   			    	/*			   			  
		   			    	if((sum_saldo_mb_d-sum_saldo_mb_h)>0){
		   			    		sum_saldo_mb_d=sum_saldo_mb_d-sum_saldo_mb_h;
		   			    		sum_saldo_mb_h='';
		   			    	}
		   			    	else{
		   			    		sum_saldo_mb_d='';
		   			    		sum_saldo_mb_h=sum_saldo_mb_h-sum_saldo_mb_d;
		   			    	}*/
		   			    	//console.log('->',sum_saldo_mb_d,'--',sum_saldo_mb_h,'--',sum_debe,'--',sum_haber);
		   			    	Ext.util.Format.number(value,'0,000.00')
		   			    	///		   			    			   			    
		   			    	Ext.util.Format.number(value,'0,000.00')
		   			    	
		   			    	//vista en dolares		   			    	
		   			    	var debe_mt = record.data["importe_debe_mt"]?record.data["importe_debe_mt"]:0,
		   			    		haber_mt = record.data["importe_haber_mt"]?record.data["importe_haber_mt"]:0,
		   			    		sum_debe_mt, 
		   			    		sum_haber_mt,
		   			    		sum_saldo_mt,
		   			    		sum_saldo_mt_d,
		   			    		sum_saldo_mt_h;	
		   			    	///		   			    		
		   			    	var saldo_mt = record.data["saldo_mt"]?record.data["saldo_mt"]:0;
		   			    	if(saldo_mt>0){
		   			    		sum_saldo_mt_d=saldo_mt;
		   			    		sum_saldo_mt_h=0;
		   			    	}else{
		   			    		sum_saldo_mt_d=0;
		   			    		sum_saldo_mt_h=saldo_mt;
		   			    	}
		   			    	///		
		   			    	
		   			    	if ((debe_mt - haber_mt ) > 0) {
		   			    		sum_debe_mt = debe_mt - haber_mt;
		   			    		sum_haber_mt = '';
		   			    	}
		   			    	else{
		   			    		sum_debe_mt = '';
		   			    		sum_haber_mt = haber_mt - debe_mt;
		   			    	}
		   			    	///
		   			    	sum_saldo_mt_d=sum_debe_mt + parseFloat(sum_saldo_mt_d,2);
		   			    	sum_saldo_mt_h=sum_haber_mt + parseFloat(sum_saldo_mt_h,2);
		   			    			   			    	
		   			    	if((sum_saldo_mt_d-sum_saldo_mt_h)>0){
		   			    		sum_saldo_mt_d=sum_saldo_mt_d-sum_saldo_mt_h;
		   			    		sum_saldo_mt_h='';
		   			    	}
		   			    	else{
		   			    		sum_saldo_mt_d='';
		   			    		sum_saldo_mt_h=sum_saldo_mt_h-sum_saldo_mt_d;
		   			    	}
		   			    	Ext.util.Format.number(value,'0,000.00')
		   			    	///		   
		   			    	Ext.util.Format.number(value,'0,000.00')

	   			    		var html = String.format("<table style='width:70%; border-collapse:collapse;'> \
		   			    							  <tr>\
													    <td >Debe BS </td>\
													    <td >Haber BS</td> \
													  </tr>\
													  <tr>\
													    <td style='padding: 8px; border-top:  solid #000000; border-right:  solid #000000;'>{0} </td>\
													    <td style='padding: 8px; border-top:  solid #000000;'>{1}</td> \
													  </tr>\
													  <tr>\
													    <td style='padding: 8px; border-right: solid #000000;'>{2}</td>\
													    <td style='padding: 8px;' >{3}</td>\
													  </tr>\
													  <tr>\
													  	<td style='padding: 6px;' >Incluye el saldo(BS)</td>\
													  </tr>\
													  <tr>\
													    <td style='padding: 8px; border-top:  solid #000000; border-right:  solid #000000;'>{8} </td>\
													    <td style='padding: 8px; border-top:  solid #000000;'>{9}</td>\
													  </tr>\
													  </table>\
													   <br>\
													  <table style='width:70%; border-collapse:collapse;'> \
		   			    							  <tr>\
													    <td >Debe USD</td>\
													    <td >Haber USD</td> \
													  </tr>\
		   			    	                          <tr>\
													    <td style='padding: 8px; border-top:  solid #000000; border-right:  solid #000000;'>{4} </td>\
													    <td style='padding: 8px; border-top:  solid #000000;'>{5}</td> \
													  </tr>\
													  <tr>\
													    <td style='padding: 8px; border-right: solid #000000;'>{6}</td>\
													    <td style='padding: 8px;' >{7}</td>\
													  </tr>\
													  <tr>\
													  	<td style='padding: 6px;' >Incluye el saldo(USD)</td>\
													  </tr>\
													  <tr>\
													    <td style='padding: 8px; border-top:  solid #000000; border-right:  solid #000000;'>{10} </td>\
													    <td style='padding: 8px; border-top:  solid #000000;'>{11}</td>\
													  </tr>\
													  </table>" ,
													   Ext.util.Format.number(debe,'0,000.00'), 
													   Ext.util.Format.number(haber,'0,000.00'), 
													   Ext.util.Format.number(sum_debe,'0,000.00'),
													   Ext.util.Format.number(sum_haber,'0,000.00'),
													  			 
													   Ext.util.Format.number(debe_mt,'0,000.00'), 
													   Ext.util.Format.number(haber_mt,'0,000.00'), 
													   Ext.util.Format.number(sum_debe_mt,'0,000.00'),
													   Ext.util.Format.number(sum_haber_mt,'0,000.00'),													   													   
													   
													   Ext.util.Format.number(sum_saldo_mb_d,'0,000.00'),
													   Ext.util.Format.number(sum_saldo_mb_h,'0,000.00'),
													   
													   Ext.util.Format.number(sum_saldo_mt_d,'0,000.00'),
													   Ext.util.Format.number(sum_saldo_mt_h,'0,000.00')
												);
		   			    	
		   			    	Phx.CP.getPagina(me.idContenedorPadre).panelResumen.update(html)
		   			    	return '<b><p align="right">Total: &nbsp;&nbsp; </p></b>';
		   			    }
		   			    
		   			}
	       	     },
	   			type:'ComboRec',
	   			id_grupo:0,
	   			filters:{	
			        pfiltro:'cue.nombre_cuenta#cue.nro_cuenta#cc.codigo_cc#cue.nro_cuenta#cue.nombre_cuenta#aux.codigo_auxiliar#aux.nombre_auxiliar#par.codigo#par.nombre_partida#ot.desc_orden',
					type:'string'
				},
	   			grid:true,
	   			form:true
		   	},
		   	{
	   			config:{
	   				sysorigen:'sis_contabilidad',
	       		    name:'id_auxiliar',
	   				origen:'AUXILIAR',
	   				allowBlank:true,
	   				fieldLabel:'Auxiliar',
	   				gdisplayField:'desc_auxiliar',//mapea al store del grid
	   				gwidth:200,
	   				width: 350,
	   				listWidth: 350,
	   				//anchor: '80%',
		   			renderer:function (value, p, record){return String.format('{0}', record.data['desc_auxiliar']);}
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
            {//#91
                config:{
                    name: 'beneficiario',
                    fieldLabel: 'Beneficiario',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 300,
                    maxLength:1000,
                },
                type:'TextArea',
                filters:{pfiltro:'beneficiario',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
		   	{
	   			config:{
	   				sysorigen:'sis_presupuestos',
	       		    name:'id_partida',
	   				origen:'PARTIDA',
	   				allowBlank:false,
	   				fieldLabel:'Partida',
	   				gdisplayField:'desc_partida',//mapea al store del grid
	   				gwidth:200,
	   				width: 350,
	   				listWidth: 350,
		   			renderer:function (value, p, record){return String.format('{0}',record.data['desc_partida']);}
	       	     },
	   			type:'ComboRec',
	   			id_grupo:0,
	   			filters:{	
			        pfiltro: 'par.codigo_partida#au.nombre_partida',
					type: 'string'
				},
	   		   
	   			grid:true,
	   			form:true
		   	},
		   	{
	            config:{
	                name: 'id_centro_costo',
	                fieldLabel: 'Centro Costo',
	                allowBlank: false,
	                tinit:false,
	                origen:'CENTROCOSTO',
	                gdisplayField: 'desc_centro_costo',
	                width: 350,
	   				listWidth: 350,
	                gwidth: 300,
	                renderer:function (value, p, record){return String.format('{0}',record.data['desc_centro_costo']);}
	            },
	            type:'ComboRec',
	            filters:{pfiltro:'cc.codigo_cc',type:'string'},
	            id_grupo:1,
	            grid:true,
	            form:true
	        },
	        {
	            config:{
	                    name:'id_orden_trabajo',
	                    fieldLabel: 'Orden Trabajo',
	                    sysorigen:'sis_contabilidad',
		       		    origen:'OT',
	                    allowBlank:true,
	                    gwidth:200,
	                    width: 350,
	   				    listWidth: 350,
	                    renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden']);}
	            
	            },
	            type:'ComboRec',
	            id_grupo:0,
	            filters:{pfiltro:'ot.motivo_orden#ot.desc_orden',type:'string'},
	            grid:false,
	            form:true
	        },
	        {
				config:{
					name: 'glosa',
					fieldLabel: 'Glosa',
					allowBlank: true,
					anchor: '80%',
					gwidth: 300,
					maxLength:1000,
					renderer: function(value, metaData, record, rowIndex, colIndex, store) {
                          metaData.css = 'multilineColumn'; 
                          return String.format('{0} <br> {1}', record.data['glosa1'], value);
                     }
				},
				type:'TextArea',
				filters:{pfiltro:'transa.glosa',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
			},
			
	        
			{
				config: {
					name: 'importe_debe_mb',
					fieldLabel: 'Debe MB',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_debe_mb',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config: {
					name: 'importe_haber_mb',
					fieldLabel: 'Haber MB',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_haber_mb',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config: {
					name: 'dif',
					fieldLabel: 'SALDO',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function(value,p,record){
						if (record.data['dif']<0) {						
							return String.format('{0}', '<FONT COLOR="red"><b>'+Ext.util.Format.number(record.data['dif'],'0,000.00')+'</b></FONT>');						
						}else{
							if (record.data['saldo']==0.00) {
								return String.format('{0}', '<FONT size=3><b>'+Ext.util.Format.number(record.data['dif'],'0,000.00')+'</b></FONT>');		
							}else{
								return String.format('{0}', '<FONT COLOR="green"><b>'+Ext.util.Format.number(record.data['dif'],'0,000.00')+'</b></FONT>');
							}							
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_debe_mb-transa.importe_haber_mb',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config: {
					name: 'importe_debe_mt',
					fieldLabel: 'Debe MT',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_debe_mt',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config: {
					name: 'importe_haber_mt',
					fieldLabel: 'Haber MT',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_haber_mt',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			
			{
				config: {
					name: 'importe_debe_ma',
					fieldLabel: 'Debe MA',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_debe_ma',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config: {
					name: 'importe_haber_ma',
					fieldLabel: 'Haber MA',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_haber_ma',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},	
			{
				config: {
					name: 'saldo_mb',
					fieldLabel: 'SALDO MB',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){	
						t_mb=value;					
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'saldo_mb',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config: {
					name: 'saldo_mt',
					fieldLabel: 'SALDO MT',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						t_mt=value;
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'saldo_mt',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},			
			{
				config:{
					name: 'fecha',
					fieldLabel: 'Fecha',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					format: 'd/m/Y', 
					renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
				},
				type:'DateField',
				filters:{pfiltro:'fecha',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
			},
			
			{
				config:{
					name: 'nro_tramite',
					fieldLabel: 'Num Tramite.',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					maxLength:10
				},
				type:'Field',
				filters:{pfiltro:'nro_tramite',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			
			{
				config: {
					name: 'tipo_cambio',
					fieldLabel: 'Tipo Cambio ',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.tipo_cambio',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config: {
					name: 'tipo_cambio_2',
					fieldLabel: 'Tipo de Cambio MT',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100
					
				},
				type: 'NumberField',
				filters: {pfiltro: 'tipo_cambio_2',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config: {
					name: 'tipo_cambio_3',
					fieldLabel: 'Tipo de Cambio MA',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
				},
				type: 'NumberField',
				filters: {pfiltro: 'tipo_cambio_3',type: 'numeric'},
				id_grupo: 1,
				grid: true,
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
				type:'Field',
				filters:{pfiltro:'transa.estado_reg',type:'string'},
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
					renderer:function (value,p,record)
					{
						return value?value.dateFormat('d/m/Y H:i:s'):''
					}
				},
				type:'DateField',
				filters:{pfiltro:'fecha_reg',type:'date'},
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
				filters:{pfiltro:'transa.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
			},
			{
				config:{
					name: 'glosa1',
					fieldLabel: 'glosa cbte',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					maxLength:10
				},
				type:'Field',
				filters:{pfiltro:'glosa1',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			{
				config:{
					name: 'codigo_cc',
					fieldLabel: 'Ce Co',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					maxLength:10
				},
				type:'Field',
				filters:{pfiltro:'codigo_cc',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			{
				config:{
					name: 'nro_cbte',
					fieldLabel: 'nro_cbte',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					maxLength:10
				},
				type:'Field',
				filters:{pfiltro:'nro_cbte',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
            //#102
            {
                config:{
                    name: 'nro_tramite_auxiliar',
                    fieldLabel: 'Num Tram Auxiliar',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:10
                },
                type:'Field',
                filters:{pfiltro:'nro_tramite_auxiliar',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
		];
			
		
		
    	//llama al constructor de la clase padre
		Phx.vista.IntTransaccionMayor.superclass.constructor.call(this,config);
        this.addButton('ReportExcel',{
            grupo:[0,1],
            text :'Exportar Excel',
            iconCls : 'bpdf32',
            disabled: true,
            handler : this.onButtonReporteExcel
        });
		this.addButton('chkdep',{	text:'Dependencias',
				iconCls: 'blist',
				disabled: true,
				handler: this.checkDependencias,
				tooltip: '<b>Revisar Dependencias </b><p>Revisar dependencias del comprobante</p>'
			});
			
		 this.addButton('btnChequeoDocumentosWf',
	            {
	                text: 'Documentos',
	                grupo:[0,1,2,3],
	                iconCls: 'bchecklist',
	                disabled: true,
	                handler: this.loadCheckDocumentosWf,
	                tooltip: '<b>Documentos del Trámite</b><br/>Permite ver los documentos asociados al NRO de trámite.'
	            }
	        );	
	      
	      this.addButton('chkpresupuesto',{text:'Chk Presupuesto',
				iconCls: 'blist',
				disabled: true,
				handler: this.checkPresupuesto,
				tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para el tramite</p>'
			});
			
		 this.addButton('btnImprimir', {
				text : 'Imprimir',
				iconCls : 'bprint',
				disabled : true,
				handler : this.imprimirCbte,
				tooltip : '<b>Imprimir Comprobante</b><br/>Imprime el Comprobante en el formato oficial'
		});
		
		this.addButton('btnDocCmpVnt', {
				text : 'Doc Cmp/Vnt',
				iconCls : 'brenew',
				disabled : true,
				handler : this.loadDocCmpVnt,
				tooltip : '<b>Documentos de compra/venta</b><br/>Muestras los docuemntos relacionados con el comprobante'
			});
			
		//mp/mp
		this.addBotonesLibroMayor();			
		this.addSaldo();
			
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.init();

	},
	
	
	tam_pag: 50,	
	
	ActList: '../../sis_contabilidad/control/IntTransaccion/listarIntTransaccionMayor',
	id_store: 'id_int_transaccion',
	fields: [
		{ name:'id_int_transaccion', type: 'numeric'},
		{ name:'id_partida', type: 'numeric'},
		{ name:'id_centro_costo', type: 'numeric'},
		{ name:'id_partida_ejecucion', type: 'numeric'},
		{ name:'estado_reg', type: 'string'},
		{ name:'id_int_transaccion_fk', type: 'numeric'},
		{ name:'id_cuenta', type: 'numeric'},
		{ name:'glosa', type: 'string'},
		{ name:'id_int_comprobante', type: 'numeric'},
		{ name:'id_auxiliar', type: 'numeric'},
		{ name:'id_usuario_reg', type: 'numeric'},
		{ name:'fecha_reg', type: 'date',dateFormat:'Y-m-d'},
		{ name:'id_usuario_mod', type: 'numeric'},
		{ name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{ name:'usr_reg', type: 'string'},
		{ name:'usr_mod', type: 'string'},
		{ name:'importe_debe', type: 'numeric'},
		{ name:'importe_haber', type: 'numeric'},
		{ name:'importe_gasto', type: 'numeric'},
		{ name:'importe_recurso', type: 'numeric'},
		{ name:'importe_debe_mb', type: 'numeric'},
		{ name:'importe_haber_mb', type: 'numeric'},
		{ name:'importe_gasto_mb', type: 'numeric'},
		{ name:'importe_recurso_mb', type: 'numeric'},
		
		{ name:'importe_debe_mt', type: 'numeric'},
		{ name:'importe_haber_mt', type: 'numeric'},
		{ name:'importe_gasto_mt', type: 'numeric'},
		{ name:'importe_recurso_mt', type: 'numeric'},
		
		{ name:'importe_debe_ma', type: 'numeric'},
		{ name:'importe_haber_ma', type: 'numeric'},
		{ name:'importe_gasto_ma', type: 'numeric'},
		{ name:'importe_recurso_ma', type: 'numeric'},
		
		{ name:'desc_cuenta', type: 'string'},
		{ name:'desc_auxiliar', type: 'string'},
		{ name:'desc_partida', type: 'string'},
		{ name:'desc_centro_costo', type: 'string'},
		{ name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{ name:'codigo_cc', type: 'string'},
		{ name:'glosa_1', type: 'string'},
		{ name:'saldo_mb', type: 'numeric'},
		{ name:'saldo_mt', type: 'numeric'},
		{ name:'dif', type: 'numeric'},
		'cbte_relacional',
		'tipo_partida','id_orden_trabajo','desc_orden',
		'tipo_reg','nro_cbte','nro_tramite','nombre_corto','glosa1',
		'id_proceso_wf','id_estado_wf','id_suborden','desc_suborden','tipo_cambio','tipo_cambio_2','tipo_cambio_3','actualizacion',
        'beneficiario',//#91
        'nro_tramite_auxiliar'//#102
		
	],
	
	
	rowExpander: new Ext.ux.grid.RowExpander({
	        tpl : new Ext.Template(
	            '<br>',	    
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Cbte:&nbsp;&nbsp;</b> {nro_cbte} - {nombre_corto}</p>',	            
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Trámite:&nbsp;&nbsp;</b> {nro_tramite} &nbsp; {fecha:date("d/m/Y")}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Creado por:&nbsp;&nbsp;</b> {usr_reg}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Estado Registro:&nbsp;&nbsp;</b> {estado_reg}</p><br>'
	        )
    }),
    
    arrayDefaultColumHidden:['fecha_mod','usr_reg','usr_mod','estado_reg','fecha_reg','id_auxiliar','tipo_cambio','tipo_cambio_2','tipo_cambio_3'],

    sortInfo:{
		field: 'id_int_transaccion',
		direction: 'ASC'
	},
	bdel: true,
	bsave: false,
	loadValoresIniciales:function(){
		Phx.vista.IntTransaccionMayor.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_int_comprobante').setValue(this.maestro.id_int_comprobante);		
	},
		
	onReloadPage:function(param){
		//Se obtiene la gestión en función de la fecha del comprobante para filtrar partidas, cuentas, etc.
		var me = this;
		this.initFiltro(param);
	},
	
	initFiltro: function(param){
		this.store.baseParams=param;
		this.load( { params: { start:0, limit: this.tam_pag } });
	},
	
	preparaMenu : function(n) {
		var rec=this.sm.getSelected();
		if(rec.data.tipo_reg != 'summary'){
			var tb = Phx.vista.IntTransaccionMayor.superclass.preparaMenu.call(this);
			this.getBoton('chkdep').enable();
			this.getBoton('btnChequeoDocumentosWf').enable();
			this.getBoton('btnImprimir').enable();
			this.getBoton('chkpresupuesto').enable();
			this.getBoton('btnDocCmpVnt').enable();
			
			return tb;
		}
		else{
			 this.getBoton('chkdep').disable();
			 this.getBoton('btnChequeoDocumentosWf').disable();
			 this.getBoton('btnImprimir').disable();
			 this.getBoton('chkpresupuesto').disable();
			 this.getBoton('btnDocCmpVnt').disable();
		 }
			
         return undefined;
	},
	liberaMenu : function() {
			var tb = Phx.vista.IntTransaccionMayor.superclass.liberaMenu.call(this);
			this.getBoton('chkdep').disable();
			this.getBoton('btnChequeoDocumentosWf').disable();
			this.getBoton('btnImprimir').disable();
			this.getBoton('chkpresupuesto').disable();
			this.getBoton('btnDocCmpVnt').disable();
			
			
	},
	
	
	getGestion:function(x){
		if(Ext.isDate(x)){
	        Ext.Ajax.request({ 
	                    url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
	                    params:{fecha:x},
	                    success:this.successGestion,
	                    failure: this.conexionFailure,
	                    timeout:this.timeout,
	                    scope:this
	        });
		} else{
			alert('Error al obtener gestión: fecha inválida')
		}
	},
	
	checkDependencias: function(){                   
			  var rec=this.sm.getSelected();
			  var configExtra = [];
			  this.objChkPres = Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_comprobante/CbteDependencias.php',
										'Dependencias',
										{
											modal:true,
											width: '80%',
											height: '80%'
										}, 
										  {id_int_comprobante: rec.data.id_int_comprobante}, 
										  this.idContenedor,
										 'CbteDependencias');
			   
	},
	imprimirCbte : function() {
			var rec = this.sm.getSelected();
			var data = rec.data;
			if (data) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_contabilidad/control/IntComprobante/reporteCbte',
					params : {
						'id_proceso_wf' : data.id_proceso_wf
					},
					success : this.successExport,
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			}

		},
	checkPresupuesto:function(){                   
			  var rec=this.sm.getSelected();
			  var configExtra = [];
			  this.objChkPres = Phx.CP.loadWindows('../../../sis_presupuestos/vista/presup_partida/ChkPresupuesto.php',
										'Estado del Presupuesto',
										{
											modal:true,
											width:700,
											height:450
										}, {
											data:{
											   nro_tramite: rec.data.nro_tramite								  
											}}, this.idContenedor,'ChkPresupuesto',
										{
											config:[{
													  event:'onclose',
													  delegate: this.onCloseChk												  
													}],
											
											scope:this
										 });
			   
	 },
	successGestion: function(resp){
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            var id_gestion = reg.ROOT.datos.id_gestion;
	        //Setea los stores de partida, cuenta, etc. con la gestion obtenida
			Ext.apply(this.Cmp.id_cuenta.store.baseParams,{id_gestion: id_gestion})
			Ext.apply(this.Cmp.id_partida.store.baseParams,{id_gestion: id_gestion})
			Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: id_gestion})
           
        } else{
            alert('Error al obtener la gestión. Cierre y vuelva a intentarlo')
        } 
	},
	 loadCheckDocumentosWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
           );
    },
    
    loadDocCmpVnt : function() {
			var rec = this.sm.getSelected();
			Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVentaCbte.php', 'Documentos del Cbte', {
				width : '80%',
				height : '80%'
			}, rec.data, this.idContenedor, 'DocCompraVentaCbte');
	},
	
	ExtraColumExportDet:[{ 
		   	    label:'Partida',
				name:'desc_partida',
				width:'200',
				type:'string',
				gdisplayField:'desc_partida',
				value:'desc_partida'
			},
			{	
				label:'Cbte',
				name:'nro_cbte',
				width:'100',
				type:'string',
				gdisplayField:'nro_cbte',
				value:'nro_cbte'
			}],
	//#17
	postReloadPage:function(data){	
		ini=data.desde;
		fin=data.hasta;
		
		aux=data.auxiliar;		
		gest=data.gest;		
		depto=data.dpto;		
		
		config_tipo_cuenta=data.tpocuenta;
		config_subtipo_cuenta=data.subtpocuenta;
		cuenta=data.cuenta;
		partida=data.partida;
		tipo_cc=data.tcc;				
		centro_costo=data.cc;							
		orden_trabajo=data.ot ;				
		suborden=data.suborden;		
		nro_tram=data.nro_tramite;
		//nro_tram_aux=data.nro_tramite_aux; 	// aun no se subio esta parte de codigo
		//
		tipo_filtro=data.tipo_filtro;			
		id_auxiliar=data.id_auxiliar;
		id_centro_costo=data.id_centro_costo;
		id_config_subtipo_cuenta=data.id_config_subtipo_cuenta;
		id_config_tipo_cuenta=data.id_config_tipo_cuenta;
		id_cuenta=data.id_cuenta;
		id_depto=data.id_depto;
		id_gestion=data.id_gestion;
		id_orden_trabajo=data.id_orden_trabajo;
		id_partida=data.id_partida;
		id_suborden=data.id_suborden;
		id_tipo_cc=data.id_tipo_cc;
		nro_tramite=data.nro_tramite;
		tipo_filtro=data.tipo_filtro;
	},
	//mpmpppmpmp
	addBotonesLibroMayor: function() {
		this.menuLibroMayor = new Ext.Toolbar.SplitButton({
			id: 'b-libro_mayor-' + this.idContenedor,
			text: 'Libro Mayor sin saldo',
			disabled: false,
			grupo:[0,1],
			iconCls : 'bprint',
			handler:this.formfiltro,
			scope: this,
			menu:{
				items: [{
					id:'b-ins-mayor-pdf-' + this.idContenedor,
					text: 'Filtrar',
					tooltip: '<b>Filtro de parametros a visualizar</b>',
					handler:this.formfiltro,
					scope: this
				}
			]}
		});
		this.tbar.add(this.menuLibroMayor);
	},
	//mp
	addSaldo: function() {
		this.menuLibroMayor = new Ext.Toolbar.SplitButton({
			id: 'c-libro_mayor-' + this.idContenedor,
			text: 'Libro Mayor con saldo',
			disabled: false,
			grupo:[0,1],
			iconCls : 'bprint',
			handler:this.formfiltroSaldo,
			scope: this,
			menu:{
				items: [{
					id:'b-ins-mayor-pdf-' + this.idContenedor,
					text: 'Filtrar',
					tooltip: '<b>Filtro de parametros a visualizar</b>',
					handler:this.formfiltroSaldo,
					scope: this
				}
			]}
		});
		this.tbar.add(this.menuLibroMayor);
	},
	//
	
	
	formfiltro:function(){	
		Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_transaccion/FormFiltroMayor.php',
			'Formulario',
			{
				modal:true,
				width:400,
				height:400
			}, 
			{
				//data:rec.data, 
				//id_depto_lb:this.store.baseParams.desc_auxiliar
			}, 
			this.idContenedor,'FormFiltroMayor',
			{
				config:[{
					event:'beforesave',
					delegate: this.addLibroMayor,
				}],
				scope:this
			}
		)
	},	
	
	//mp
	formfiltroSaldo:function(){	
		Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_transaccion/FormMayorSaldo.php',
			'Formulario Saldo',
			{
				modal:true,
				width:400,
				height:400
			}, 
			{
			}, 
			this.idContenedor,'FormMayorSaldo', 
			{
				config:[{
					event:'beforesave',
					delegate: this.addMayorSaldo,
				}],
				scope:this
			}
		)
	},	
	
	addLibroMayor : function (wizard,resp){
		//tipo_filtro, fechas
		Phx.CP.loadingShow();		
		Ext.Ajax.request({
			url:'../../sis_contabilidad/control/IntTransaccion/impReporteMayor',
			params:
			{	
				'desde':ini,
				'hasta':fin,
				
				'id_auxiliar':id_auxiliar,
				'id_gestion':id_gestion,
				'id_depto':id_depto,
				'id_config_tipo_cuenta':id_config_tipo_cuenta,
				'id_config_subtipo_cuenta':id_config_subtipo_cuenta,
				'id_cuenta':id_cuenta,
				'id_partida':id_partida,
				'id_tipo_cc':id_tipo_cc,				
				'id_centro_costo':id_centro_costo,																						
				'id_orden_trabajo':id_orden_trabajo,								
				'id_suborden':id_suborden,				
				'nro_tramite':nro_tramite,				
				//				
				'aux':aux,
				'gest':gest,
				'depto':depto,								
				'config_tipo_cuenta':config_tipo_cuenta,
				'config_subtipo_cuenta':config_subtipo_cuenta,
				'cuenta':cuenta,
				'partidas':partida,				
				'tipo_cc':tipo_cc,
				'centro_costo':centro_costo,
				'orden_trabajo':orden_trabajo,
				'suborden':suborden,
				'nro_tram':nro_tram,
				//'nro_tram_aux':nro_tram_aux,			// aun no se subio esta parte de codigo
				//formato pdf o xls
				'tipo_filtro':tipo_filtro,			
				//parametros q se mostraran, si son tickeados						
				'tipo_moneda':resp.tipo_moneda,
				'cc':resp.cc,
				'partida':resp.partida,
				'auxiliar':resp.auxiliar,
				'ordenes':resp.ordenes,
				'tramite':resp.nro_tramite,
				'nro_comprobante':resp.nro_comprobante,
				'tipo_formato':resp.tipo_formato,
				'relacional':resp.relacional,
				'fec':resp.fec,
				'cuenta_t':resp.cuenta_t
			},
			//argument:{wizard:wizard},
			success: this.successExport,		
			failure: this.conexionFailure,
			timeout: 4.6e+7,
			scope:this
		});
	},
	//
	
	//mp
	addMayorSaldo : function (wizard,resp){		
		Phx.CP.loadingShow();		
		Ext.Ajax.request({
			url:'../../sis_contabilidad/control/IntTransaccion/impReporteMayorSaldo',
			params:
			{	
				'desde':ini,
				'hasta':fin,
				
				'id_auxiliar':id_auxiliar,
				'id_gestion':id_gestion,
				'id_depto':id_depto,
				'id_config_tipo_cuenta':id_config_tipo_cuenta,
				'id_config_subtipo_cuenta':id_config_subtipo_cuenta,
				'id_cuenta':id_cuenta,
				'id_partida':id_partida,
				'id_tipo_cc':id_tipo_cc,				
				'id_centro_costo':id_centro_costo,																						
				'id_orden_trabajo':id_orden_trabajo,								
				'id_suborden':id_suborden,				
				'nro_tramite':nro_tramite,				
				//				
				'aux':aux,
				'gest':gest,
				'depto':depto,								
				'config_tipo_cuenta':config_tipo_cuenta,
				'config_subtipo_cuenta':config_subtipo_cuenta,
				'cuenta':cuenta,
				'partidas':partida,				
				'tipo_cc':tipo_cc,
				'centro_costo':centro_costo,
				'orden_trabajo':orden_trabajo,
				'suborden':suborden,
				'nro_tram':nro_tram,	
				//'nro_tram_aux':nro_tram_aux,// aun no se subio esta parte de codigo
				//formato pdf o xls
				'tipo_filtro':tipo_filtro,
				//parametros q se mostraran, si son tickeados						
				'tipo_moneda':resp.tipo_moneda,
				'cc':resp.cc,
				'partida':resp.partida,
				'auxiliar':resp.auxiliar,
				'ordenes':resp.ordenes,
				'tramite':resp.nro_tramite,
				'nro_comprobante':resp.nro_comprobante,
				'tipo_formato':resp.tipo_formato,
				'relacional':resp.relacional,
				'fec':resp.fec,
				'cuenta_t':resp.cuenta_t
			},
			success: this.successExport,		
			failure: this.conexionFailure,
			timeout: 4.6e+7,
			scope:this
		});
    },
    onButtonReporteExcel:function(){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/IntTransaccion/reporteExcelTransaccion',
            params:
                {    'desde':ini,
                    'hasta':fin,
                    'id_auxiliar':id_auxiliar,
                    'id_gestion':id_gestion,
                    'id_depto':id_depto,
                    'id_config_tipo_cuenta':id_config_tipo_cuenta,
                    'id_config_subtipo_cuenta':id_config_subtipo_cuenta,
                    'id_cuenta':id_cuenta,
                    'id_partida':id_partida,
                    'id_tipo_cc':id_tipo_cc,
                    'id_centro_costo':id_centro_costo,
                    'id_orden_trabajo':id_orden_trabajo,
                    'id_suborden':id_suborden,
                    'nro_tramite':nro_tramite,
                    //
                    'aux':aux,
                    'gest':gest,
                    'depto':depto,
                    'config_tipo_cuenta':config_tipo_cuenta,
                    'config_subtipo_cuenta':config_subtipo_cuenta,
                    'cuenta':cuenta,
                    'partidas':partida,
                    'tipo_cc':tipo_cc,
                    'centro_costo':centro_costo,
                    'orden_trabajo':orden_trabajo,
                    'suborden':suborden,
                    'nro_tram':nro_tram
                },
            success: this.successExport,
            failure: this.conexionFailure,
            timeout: 4.6e+7,
            scope:this
        });
    },
    bnew : false,
    bedit: false,
    bdel:  false,
    bexcel: true //#20 #22
})
</script>
		
		