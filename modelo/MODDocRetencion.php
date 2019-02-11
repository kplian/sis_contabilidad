<?php
/**
*@package pXP
*@file gen-MODDocRetencion.php
*@author  (manu)
*@date 18-08-2015 15:57:09
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/
class MODDocRetencion extends MODbase{
	//
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}	
	//
	function listarRetForm(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_doc_retencion_sel';
		$this->transaccion='CONTA_REPRET_FRM';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		
		$this->setParametro('filtro_sql','filtro_sql','VARCHAR');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('tipo_ret','tipo_ret','VARCHAR');
		$this->setParametro('fecha_ini','fecha_ini','DATE');
		$this->setParametro('fecha_fin','fecha_fin','DATE');
		$this->setParametro('id_gestion','id_gestion','int4');

		$this->captura('id_doc_compra_venta','BIGINT');
		$this->captura('tipo','VARCHAR');
		$this->captura('fecha','DATE');
		$this->captura('nit','VARCHAR');
		$this->captura('razon_social','VARCHAR');
		
		$this->captura('nro_documento','VARCHAR');		
		$this->captura('tipo_doc','VARCHAR');
		$this->captura('id_plantilla','INTEGER');
		$this->captura('tipo_informe','VARCHAR');		
		$this->captura('id_moneda','INTEGER');
		
		$this->captura('codigo_moneda','VARCHAR');
		$this->captura('id_periodo','INTEGER');
		$this->captura('id_gestion','INTEGER');
		$this->captura('id_usuario_reg','VARCHAR');
		$this->captura('importe_doc','NUMERIC');
		
		$this->captura('importe_descuento_ley','NUMERIC');
		$this->captura('obs','VARCHAR');
		$this->captura('nro_tramite','VARCHAR');
		$this->captura('usr_mod','VARCHAR');
		$this->captura('plantilla','VARCHAR');
		
		$this->captura('id_int_comprobante','int4');
		$this->captura('nro_cbte','VARCHAR');
		$this->captura('tipo_cambio','NUMERIC');	
		$this->captura('it','NUMERIC');
		
		$this->captura('it_bienes','NUMERIC');
		$this->captura('it_servicios','NUMERIC');
		$this->captura('it_alquileres','NUMERIC');
		$this->captura('it_directores','NUMERIC');
				
		$this->captura('iue_iva','NUMERIC');
		 
		$this->captura('iue_iva_total','NUMERIC');
		
		$this->captura('iue_bienes','NUMERIC');
		$this->captura('iue_servicios','NUMERIC');
		$this->captura('rc_iva_alquileres','NUMERIC');
		$this->captura('rc_iva_directores','NUMERIC');
		$this->captura('rc_iva_retirados','NUMERIC');
		 
		$this->captura('descuento','NUMERIC');
		$this->captura('liquido','NUMERIC');	
		
		$this->captura('bienes','VARCHAR');	
		$this->captura('servicios','VARCHAR');	
		$this->captura('alquileres','VARCHAR');
		$this->captura('directores','VARCHAR');	

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}	

		////////////////EGS///////////////////
	function listarInvoiceIUE(){
		
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_doc_invokeiue_sel';
		$this->transaccion='CONTA_INVOUE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		
		$this->setParametro('filtro_sql','filtro_sql','VARCHAR');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('tipo_ret','tipo_ret','VARCHAR');
		$this->setParametro('fecha_ini','fecha_ini','DATE');
		$this->setParametro('fecha_fin','fecha_fin','DATE');
		$this->setParametro('id_gestion','id_gestion','int4');
		
		$this->captura('id_doc_compra_venta','int8');
		$this->captura('revisado','varchar');
		$this->captura('movil','varchar');
		$this->captura('tipo','varchar');
		$this->captura('importe_excento','numeric');
		$this->captura('id_plantilla','int4');
		$this->captura('fecha','date');
		$this->captura('nro_documento','varchar');
		$this->captura('nit','varchar');
		$this->captura('importe_ice','numeric');
		$this->captura('nro_autorizacion','varchar');
		$this->captura('importe_iva','numeric');
		$this->captura('importe_descuento','numeric');
		$this->captura('importe_doc','numeric');
		$this->captura('sw_contabilizar','varchar');
		$this->captura('tabla_origen','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_depto_conta','int4');
		$this->captura('id_origen','int4');
		$this->captura('obs','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo_control','varchar');
		$this->captura('importe_it','numeric');
		$this->captura('razon_social','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('desc_depto','varchar');
		$this->captura('desc_plantilla','varchar');
		$this->captura('importe_descuento_ley','numeric');
		$this->captura('importe_pago_liquido','numeric');
		$this->captura('nro_dui','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('desc_moneda','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('nro_tramite','varchar');
		$this->captura('desc_comprobante','varchar');
		
		
		$this->captura('importe_pendiente','numeric');
		$this->captura('importe_anticipo','numeric');
		$this->captura('importe_retgar','numeric');
		$this->captura('importe_neto','numeric');		
		$this->captura('id_auxiliar','integer');
		$this->captura('codigo_auxiliar','varchar');
		$this->captura('nombre_auxiliar','varchar');		
		$this->captura('id_tipo_doc_compra_venta','integer');
		$this->captura('desc_tipo_doc_compra_venta','varchar');		
		$this->captura('importe_aux_neto','numeric');
		$this->captura('id_funcionario','integer');		
		$this->captura('desc_funcionario2','varchar');
		$this->captura('fecha_cbte','date');
		$this->captura('estado_cbte','varchar');
		$this->captura('codigo_aplicacion','varchar');
		
		$this->captura('tipo_informe','varchar');
		$this->captura('id_doc_compra_venta_fk','int8');
		$this->captura('id_periodo','integer');
		$this->captura('id_gestion','integer');
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
		
	}

	
}
?>		
