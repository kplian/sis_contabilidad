<?php
/**
*@package pXP
*@file gen-MODTransaccion.php
*@author  (admin)
*@date 22-07-2013 03:51:00
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTransaccion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTransaccion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_transaccion_sel';
		$this->transaccion='CONTA_CONTRA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_transaccion','int4');
		$this->captura('id_comprobante','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_transaccion_fk','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
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
			
	function insertarTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_transaccion_ime';
		$this->transaccion='CONTA_CONTRA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_comprobante','id_comprobante','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_transaccion_fk','id_transaccion_fk','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_transaccion_ime';
		$this->transaccion='CONTA_CONTRA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_transaccion','id_transaccion','int4');
		$this->setParametro('id_comprobante','id_comprobante','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_transaccion_fk','id_transaccion_fk','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_transaccion_ime';
		$this->transaccion='CONTA_CONTRA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_transaccion','id_transaccion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>