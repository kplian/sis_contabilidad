<?php
/**
*@package pXP
*@file gen-MODFacturaAirbp.php
*@author  (gsarmiento)
*@date 12-01-2017 21:45:40
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFacturaAirbp extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFacturaAirbp(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_factura_airbp_sel';
		$this->transaccion='CONTA_FAIRBP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_factura_airbp','int4');
		$this->captura('id_doc_compra_venta','int4');
		$this->captura('tipo_cambio','numeric');
		$this->captura('punto_venta','varchar');
		$this->captura('id_cliente','int4');
		$this->captura('estado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
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
			
	function insertarFacturaAirbp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_factura_airbp_ime';
		$this->transaccion='CONTA_FAIRBP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
		$this->setParametro('tipo_cambio','tipo_cambio','numeric');
		$this->setParametro('punto_venta','punto_venta','varchar');
		$this->setParametro('id_cliente','id_cliente','int4');
		$this->setParametro('estado','estado','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFacturaAirbp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_factura_airbp_ime';
		$this->transaccion='CONTA_FAIRBP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_factura_airbp','id_factura_airbp','int4');
		$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
		$this->setParametro('tipo_cambio','tipo_cambio','numeric');
		$this->setParametro('punto_venta','punto_venta','varchar');
		$this->setParametro('id_cliente','id_cliente','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFacturaAirbp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_factura_airbp_ime';
		$this->transaccion='CONTA_FAIRBP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_factura_airbp','id_factura_airbp','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>