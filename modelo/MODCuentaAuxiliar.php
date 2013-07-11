<?php
/**
*@package pXP
*@file gen-MODCuentaAuxiliar.php
*@author  (admin)
*@date 11-07-2013 20:37:00
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaAuxiliar extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaAuxiliar(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_cuenta_auxiliar_sel';
		$this->transaccion='CONTA_CAX_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_auxiliar','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo_auxiliar','varchar');
        $this->captura('nombre_auxiliar','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCuentaAuxiliar(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_cuenta_auxiliar_ime';
		$this->transaccion='CONTA_CAX_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaAuxiliar(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_cuenta_auxiliar_ime';
		$this->transaccion='CONTA_CAX_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_auxiliar','id_cuenta_auxiliar','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaAuxiliar(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_cuenta_auxiliar_ime';
		$this->transaccion='CONTA_CAX_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_auxiliar','id_cuenta_auxiliar','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>