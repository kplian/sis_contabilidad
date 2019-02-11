<?php
/**
*@package pXP
*@file gen-MODConfigSubtipoCuenta.php
*@author  (admin)
*@date 07-06-2017 19:52:43
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODConfigSubtipoCuenta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarConfigSubtipoCuenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_config_subtipo_cuenta_sel';
		$this->transaccion='CONTA_CST_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_config_subtipo_cuenta','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('nombre','varchar');
		$this->captura('id_config_tipo_cuenta','int4');
		$this->captura('codigo','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('tipo_cuenta','varchar');
		$this->captura('nro_base','int4');
		
	
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarConfigSubtipoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_subtipo_cuenta_ime';
		$this->transaccion='CONTA_CST_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('id_config_tipo_cuenta','id_config_tipo_cuenta','int4');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarConfigSubtipoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_subtipo_cuenta_ime';
		$this->transaccion='CONTA_CST_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_config_subtipo_cuenta','id_config_subtipo_cuenta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('id_config_tipo_cuenta','id_config_tipo_cuenta','int4');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarConfigSubtipoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_subtipo_cuenta_ime';
		$this->transaccion='CONTA_CST_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_config_subtipo_cuenta','id_config_subtipo_cuenta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>