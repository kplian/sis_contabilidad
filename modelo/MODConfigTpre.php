<?php
/**
*@package pXP
*@file gen-MODConfigTpre.php
*@author  (mguerra)
*@date 18-03-2019 16:32:29
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*issue #54	
 */

class MODConfigTpre extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarConfigTpre(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_config_tpre_sel';
		$this->transaccion='CONTA_CONTC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('desc_tcc','varchar');
		$this->captura('id_conf_pre','int4');
		$this->captura('id_tipo_cc','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('obs','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
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
			
	function insertarConfigTpre(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_tpre_ime';
		$this->transaccion='CONTA_CONTC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('obs','obs','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarConfigTpre(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_tpre_ime';
		$this->transaccion='CONTA_CONTC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_conf_pre','id_conf_pre','int4');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('obs','obs','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarConfigTpre(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_tpre_ime';
		$this->transaccion='CONTA_CONTC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_conf_pre','id_conf_pre','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>