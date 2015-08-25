<?php
/**
*@package pXP
*@file gen-MODDocCompraVenta.php
*@author  (admin)
*@date 18-08-2015 15:57:09
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDocCompraVenta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDocCompraVenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_doc_compra_venta_sel';
		$this->transaccion='CONTA_DCV_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
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


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarDocCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_doc_compra_venta_ime';
		$this->transaccion='CONTA_DCV_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('revisado','revisado','varchar');
		$this->setParametro('movil','movil','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('importe_excento','importe_excento','numeric');
		$this->setParametro('id_plantilla','id_plantilla','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('nro_documento','nro_documento','varchar');
		$this->setParametro('nit','nit','varchar');
		$this->setParametro('importe_ice','importe_ice','numeric');
		$this->setParametro('nro_autorizacion','nro_autorizacion','varchar');
		$this->setParametro('importe_iva','importe_iva','numeric');
		$this->setParametro('importe_descuento','importe_descuento','numeric');
		$this->setParametro('importe_doc','importe_doc','numeric');
		$this->setParametro('sw_contabilizar','sw_contabilizar','varchar');
		$this->setParametro('tabla_origen','tabla_origen','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('id_origen','id_origen','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_control','codigo_control','varchar');
		$this->setParametro('importe_it','importe_it','numeric');
		$this->setParametro('razon_social','razon_social','varchar');
		$this->setParametro('importe_descuento_ley','importe_descuento_ley','numeric');
		$this->setParametro('importe_pago_liquido','importe_pago_liquido','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDocCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_doc_compra_venta_ime';
		$this->transaccion='CONTA_DCV_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int8');
		$this->setParametro('revisado','revisado','varchar');
		$this->setParametro('movil','movil','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('importe_excento','importe_excento','numeric');
		$this->setParametro('id_plantilla','id_plantilla','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('nro_documento','nro_documento','varchar');
		$this->setParametro('nit','nit','varchar');
		$this->setParametro('importe_ice','importe_ice','numeric');
		$this->setParametro('nro_autorizacion','nro_autorizacion','varchar');
		$this->setParametro('importe_iva','importe_iva','numeric');
		$this->setParametro('importe_descuento','importe_descuento','numeric');
		$this->setParametro('importe_doc','importe_doc','numeric');
		$this->setParametro('sw_contabilizar','sw_contabilizar','varchar');
		$this->setParametro('tabla_origen','tabla_origen','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('id_origen','id_origen','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_control','codigo_control','varchar');
		$this->setParametro('importe_it','importe_it','numeric');
		$this->setParametro('razon_social','razon_social','varchar');
		$this->setParametro('importe_descuento_ley','importe_descuento_ley','numeric');
		$this->setParametro('importe_pago_liquido','importe_pago_liquido','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDocCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_doc_compra_venta_ime';
		$this->transaccion='CONTA_DCV_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int8');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

     function listarNroAutorizacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_doc_compra_venta_sel';
		$this->transaccion='CONTA_DCVNA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('nro_autorizacion','nro_autorizacion','varchar');
		
				
		//Definicion de la lista del resultado del query
		$this->captura('nro_autorizacion','varchar');
		$this->captura('nit','varchar');		
		$this->captura('razon_social','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

   function listarNroNit(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_doc_compra_venta_sel';
		$this->transaccion='CONTA_DCVNIT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('nit','nit','varchar');
		
		//Definicion de la lista del resultado del query
		$this->captura('nit','varchar');		
		$this->captura('razon_social','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

			
}
?>