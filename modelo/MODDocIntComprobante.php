<?php
/**
*@package pXP
*@file gen-MODDocIntComprobante.php
*@author  (gsarmiento)
*@date 13-03-2017 15:41:29
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDocIntComprobante extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDocIntComprobante(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_doc_int_comprobante_sel';
		$this->transaccion='CONTA_DOCCBTE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_doc_int_comprobante','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha','date');
		$this->captura('nit','varchar');
		$this->captura('razon_social','varchar');
		$this->captura('desc_plantilla','varchar');
		$this->captura('nro_documento','varchar');
		$this->captura('nro_dui','varchar');
		$this->captura('nro_autorizacion','varchar');
		$this->captura('codigo_control','varchar');
		$this->captura('importe_doc','numeric');
		$this->captura('importe_ice','numeric');
		$this->captura('importe_descuento','numeric');
		$this->captura('importe_excento','numeric');
		$this->captura('liquido','numeric');
		$this->captura('importe_sujeto','numeric');
		$this->captura('importe_iva','numeric');
		$this->captura('importe_gasto','numeric');
		$this->captura('porc_gasto_prorrateado','numeric');
		$this->captura('sujeto_prorrateado','numeric');
		$this->captura('iva_prorrateado','numeric');
		$this->captura('codigo','varchar');
		$this->captura('nro_cuenta','varchar');
		$this->captura('origen','varchar');
		$this->captura('id_int_comprobante','varchar');
		$this->captura('id_doc_compra_venta','int4');
		$this->captura('usuario','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarDocIntComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_doc_int_comprobante_ime';
		$this->transaccion='CONTA_DOCCBTE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('nit','nit','varchar');
		$this->setParametro('razon_social','razon_social','varchar');
		$this->setParametro('desc_plantilla','desc_plantilla','varchar');
		$this->setParametro('nro_documento','nro_documento','varchar');
		$this->setParametro('nro_dui','nro_dui','varchar');
		$this->setParametro('nro_autorizacion','nro_autorizacion','varchar');
		$this->setParametro('codigo_control','codigo_control','varchar');
		$this->setParametro('importe_doc','importe_doc','numeric');
		$this->setParametro('importe_ice','importe_ice','numeric');
		$this->setParametro('importe_descuento','importe_descuento','numeric');
		$this->setParametro('importe_excento','importe_excento','numeric');
		$this->setParametro('liquido','liquido','numeric');
		$this->setParametro('importe_sujeto','importe_sujeto','numeric');
		$this->setParametro('importe_iva','importe_iva','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('porc_gasto_prorrateado','porc_gasto_prorrateado','numeric');
		$this->setParametro('sujeto_prorrateado','sujeto_prorrateado','numeric');
		$this->setParametro('iva_prorrateado','iva_prorrateado','numeric');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','varchar');
		$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
		$this->setParametro('usuario','usuario','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDocIntComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_doc_int_comprobante_ime';
		$this->transaccion='CONTA_DOCCBTE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_doc_int_comprobante','id_doc_int_comprobante','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('nit','nit','varchar');
		$this->setParametro('razon_social','razon_social','varchar');
		$this->setParametro('desc_plantilla','desc_plantilla','varchar');
		$this->setParametro('nro_documento','nro_documento','varchar');
		$this->setParametro('nro_dui','nro_dui','varchar');
		$this->setParametro('nro_autorizacion','nro_autorizacion','varchar');
		$this->setParametro('codigo_control','codigo_control','varchar');
		$this->setParametro('importe_doc','importe_doc','numeric');
		$this->setParametro('importe_ice','importe_ice','numeric');
		$this->setParametro('importe_descuento','importe_descuento','numeric');
		$this->setParametro('importe_excento','importe_excento','numeric');
		$this->setParametro('liquido','liquido','numeric');
		$this->setParametro('importe_sujeto','importe_sujeto','numeric');
		$this->setParametro('importe_iva','importe_iva','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('porc_gasto_prorrateado','porc_gasto_prorrateado','numeric');
		$this->setParametro('sujeto_prorrateado','sujeto_prorrateado','numeric');
		$this->setParametro('iva_prorrateado','iva_prorrateado','numeric');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','varchar');
		$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
		$this->setParametro('usuario','usuario','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDocIntComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_doc_int_comprobante_ime';
		$this->transaccion='CONTA_DOCCBTE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_doc_int_comprobante','id_doc_int_comprobante','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarDocCompraVentaIntComprobante(){

		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_doc_int_comprobante_ime';
		$this->transaccion='CONTA_DOCINTCOMP_INS';
		$this->tipo_procedimiento='IME';//tipo de transaccion
		$this->setCount(false);

		//captura parametros adicionales para el count

		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
}
?>