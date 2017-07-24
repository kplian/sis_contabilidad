<?php
/**
*@package pXP
*@file gen-MODConfigCambiaria.php
*@author  (admin)
*@date 04-11-2015 12:39:12
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODConfigCambiaria extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarConfigCambiaria(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_config_cambiaria_sel';
		$this->transaccion='CONTA_CNFC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_config_cambiaria','int4');
		$this->captura('fecha_habilitado','date');
		$this->captura('origen','varchar');
		$this->captura('habilitado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('ope_2','varchar');
		$this->captura('ope_1','varchar');
		$this->captura('obs','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('ope_3','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarConfigCambiaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_cambiaria_ime';
		$this->transaccion='CONTA_CNFC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('fecha_habilitado','fecha_habilitado','date');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('habilitado','habilitado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('ope_2','ope_2','varchar');
		$this->setParametro('ope_1','ope_1','varchar');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('ope_3','ope_3','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarConfigCambiaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_cambiaria_ime';
		$this->transaccion='CONTA_CNFC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_config_cambiaria','id_config_cambiaria','int4');
		$this->setParametro('fecha_habilitado','fecha_habilitado','date');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('habilitado','habilitado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('ope_2','ope_2','varchar');
		$this->setParametro('ope_1','ope_1','varchar');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('ope_3','ope_3','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarConfigCambiaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_cambiaria_ime';
		$this->transaccion='CONTA_CNFC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_config_cambiaria','id_config_cambiaria','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function getConfigCambiaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_config_cambiaria_ime';
		$this->transaccion='CONTA_GETCFIG_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('localidad','localidad','varchar');
		$this->setParametro('sw_valores','sw_valores','varchar');
		$this->setParametro('forma_cambio','forma_cambio','varchar');
		
		
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>