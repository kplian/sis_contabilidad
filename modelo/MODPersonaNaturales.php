<?php
/**
*@package pXP
*@file gen-MODPersonaNaturales.php
*@author  (admin)
*@date 31-05-2017 20:17:08
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPersonaNaturales extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPersonaNaturales(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_persona_naturales_sel';
		$this->transaccion='CONTA_PNS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_persona_natural','int4');
		$this->captura('precio_unitario','numeric');
		$this->captura('descripcion','varchar');
		$this->captura('codigo_cliente','varchar');
		$this->captura('capacidad','varchar');
		$this->captura('codigo_producto','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('importe_total','numeric');
		$this->captura('nro_identificacion','int4');
		$this->captura('cantidad_producto','int4');
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
			
	function insertarPersonaNaturales(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_persona_naturales_ime';
		$this->transaccion='CONTA_PNS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo_cliente','codigo_cliente','varchar');
		$this->setParametro('capacidad','capacidad','varchar');
		$this->setParametro('codigo_producto','codigo_producto','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('importe_total','importe_total','numeric');
		$this->setParametro('nro_identificacion','nro_identificacion','int4');
		$this->setParametro('cantidad_producto','cantidad_producto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPersonaNaturales(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_persona_naturales_ime';
		$this->transaccion='CONTA_PNS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_persona_natural','id_persona_natural','int4');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo_cliente','codigo_cliente','varchar');
		$this->setParametro('capacidad','capacidad','varchar');
		$this->setParametro('codigo_producto','codigo_producto','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('importe_total','importe_total','numeric');
		$this->setParametro('nro_identificacion','nro_identificacion','int4');
		$this->setParametro('cantidad_producto','cantidad_producto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPersonaNaturales(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_persona_naturales_ime';
		$this->transaccion='CONTA_PNS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_persona_natural','id_persona_natural','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>