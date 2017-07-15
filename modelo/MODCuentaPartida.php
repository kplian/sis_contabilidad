<?php
/**
*@package pXP
*@file gen-MODCuentaPartida.php
*@author  (admin)
*@date 04-05-2017 10:19:16
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaPartida extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaPartida(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_cuenta_partida_sel';
		$this->transaccion='CONTA_CUPA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_partida','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('sw_deha','varchar');
		$this->captura('id_partida','int4');
		$this->captura('se_rega','varchar');
		$this->captura('id_cuenta','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_partida','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCuentaPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_cuenta_partida_ime';
		$this->transaccion='CONTA_CUPA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('sw_deha','sw_deha','varchar');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('se_rega','se_rega','varchar');
		$this->setParametro('id_cuenta','id_cuenta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_cuenta_partida_ime';
		$this->transaccion='CONTA_CUPA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_partida','id_cuenta_partida','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('sw_deha','sw_deha','varchar');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('se_rega','se_rega','varchar');
		$this->setParametro('id_cuenta','id_cuenta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_cuenta_partida_ime';
		$this->transaccion='CONTA_CUPA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_partida','id_cuenta_partida','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>