<?php
/**
*@package pXP
*@file gen-MODFacturaAirbpConcepto.php
*@author  (gsarmiento)
*@date 12-01-2017 21:46:08
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFacturaAirbpConcepto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFacturaAirbpConcepto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_factura_airbp_concepto_sel';
		$this->transaccion='CONTA_FCAIRBP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_factura_airbp_concepto','int4');
		$this->captura('id_factura_airbp','int4');
		$this->captura('cantidad','int4');
		$this->captura('total_bs','numeric');
		$this->captura('precio_unitario','numeric');
		$this->captura('ne','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('destino','varchar');
		$this->captura('matricula','varchar');
		$this->captura('articulo','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
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
			
	function insertarFacturaAirbpConcepto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_factura_airbp_concepto_ime';
		$this->transaccion='CONTA_FCAIRBP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_factura_airbp','id_factura_airbp','int4');
		$this->setParametro('cantidad_concepto','cantidad','int4');
		$this->setParametro('total_bs','total_bs','numeric');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('ne','ne','varchar');
		//$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('destino','destino','varchar');
		$this->setParametro('matricula','matricula','varchar');
		$this->setParametro('articulo','articulo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		//var_dump($this->consulta);
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFacturaAirbpConcepto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_factura_airbp_concepto_ime';
		$this->transaccion='CONTA_FCAIRBP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_factura_airbp_concepto','id_factura_airbp_concepto','int4');
		$this->setParametro('id_factura_airbp','id_factura_airbp','int4');
		$this->setParametro('cantidad','cantidad','int4');
		$this->setParametro('total_bs','total_bs','numeric');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('ne','ne','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('destino','destino','varchar');
		$this->setParametro('matricula','matricula','varchar');
		$this->setParametro('articulo','articulo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFacturaAirbpConcepto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_factura_airbp_concepto_ime';
		$this->transaccion='CONTA_FCAIRBP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_factura_airbp_concepto','id_factura_airbp_concepto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>