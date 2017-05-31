<?php
/**
*@package pXP
*@file gen-MODRegimenSimplificado.php
*@author  (admin)
*@date 31-05-2017 20:17:05
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODRegimenSimplificado extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarRegimenSimplificado(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_regimen_simplificado_sel';
		$this->transaccion='CONTA_RSO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_simplificado','int4');
		$this->captura('precio_unitario','numeric');
		$this->captura('descripcion','varchar');
		$this->captura('codigo_cliente','varchar');
		$this->captura('cantidad_bonificado','varchar');
		$this->captura('codigo_producto','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('descripcion_bonificado','varchar');
		$this->captura('importe_bonificado','numeric');
		$this->captura('nombre','varchar');
		$this->captura('descuento','numeric');
		$this->captura('cantidad_bonificacion','int4');
		$this->captura('cantidad_producto','int4');
		$this->captura('nit','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarRegimenSimplificado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_regimen_simplificado_ime';
		$this->transaccion='CONTA_RSO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo_cliente','codigo_cliente','varchar');
		$this->setParametro('cantidad_bonificado','cantidad_bonificado','varchar');
		$this->setParametro('codigo_producto','codigo_producto','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion_bonificado','descripcion_bonificado','varchar');
		$this->setParametro('importe_bonificado','importe_bonificado','numeric');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descuento','descuento','numeric');
		$this->setParametro('cantidad_bonificacion','cantidad_bonificacion','int4');
		$this->setParametro('cantidad_producto','cantidad_producto','int4');
		$this->setParametro('nit','nit','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarRegimenSimplificado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_regimen_simplificado_ime';
		$this->transaccion='CONTA_RSO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_simplificado','id_simplificado','int4');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo_cliente','codigo_cliente','varchar');
		$this->setParametro('cantidad_bonificado','cantidad_bonificado','varchar');
		$this->setParametro('codigo_producto','codigo_producto','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion_bonificado','descripcion_bonificado','varchar');
		$this->setParametro('importe_bonificado','importe_bonificado','numeric');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descuento','descuento','numeric');
		$this->setParametro('cantidad_bonificacion','cantidad_bonificacion','int4');
		$this->setParametro('cantidad_producto','cantidad_producto','int4');
		$this->setParametro('nit','nit','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarRegimenSimplificado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_regimen_simplificado_ime';
		$this->transaccion='CONTA_RSO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_simplificado','id_simplificado','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>