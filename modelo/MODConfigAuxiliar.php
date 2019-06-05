<?php
/**
*@package pXP
*@file gen-MODConfigAuxiliar.php
*@author  (egutierrez)
*@date 05-06-2019 15:37:13
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODConfigAuxiliar extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarConfigAuxiliar(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_config_auxiliar_sel';
		$this->transaccion='CONTA_cfga_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_config_auxiliar','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('descripcion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_auxiliar','varchar');		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarConfigAuxiliar(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_auxiliar_ime';
		$this->transaccion='CONTA_cfga_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarConfigAuxiliar(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_auxiliar_ime';
		$this->transaccion='CONTA_cfga_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_config_auxiliar','id_config_auxiliar','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarConfigAuxiliar(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_auxiliar_ime';
		$this->transaccion='CONTA_cfga_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_config_auxiliar','id_config_auxiliar','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>