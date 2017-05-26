<?php
/**
*@package pXP
*@file gen-MODConfigTipoCuenta.php
*@author  (admin)
*@date 26-02-2013 19:19:24
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODConfigTipoCuenta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarConfigTipoCuenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.f_config_tipo_cuenta_sel';
		$this->transaccion='CONTA_CTC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cofig_tipo_cuenta','int4');
		$this->captura('nro_base','int4');
		$this->captura('tipo_cuenta','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('incremento','varchar');
		$this->captura('eeff','varchar');
		$this->captura('movimiento','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarConfigTipoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_config_tipo_cuenta_ime';
		$this->transaccion='CONTA_CTC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('nro_base','nro_base','int4');
		$this->setParametro('tipo_cuenta','tipo_cuenta','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('incremento','incremento','varchar');
		$this->setParametro('eeff','eeff','varchar');
		$this->setParametro('movimiento','movimiento','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarConfigTipoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_config_tipo_cuenta_ime';
		$this->transaccion='CONTA_CTC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cofig_tipo_cuenta','id_cofig_tipo_cuenta','int4');
		$this->setParametro('nro_base','nro_base','int4');
		$this->setParametro('tipo_cuenta','tipo_cuenta','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('incremento','incremento','varchar');
		$this->setParametro('eeff','eeff','varchar');
		$this->setParametro('movimiento','movimiento','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarConfigTipoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_config_tipo_cuenta_ime';
		$this->transaccion='CONTA_CTC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cofig_tipo_cuenta','id_cofig_tipo_cuenta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>