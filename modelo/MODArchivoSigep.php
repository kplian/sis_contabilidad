<?php
/**
*@package pXP
*@file gen-MODArchivoSigep.php
*@author  (gsarmiento)
*@date 10-05-2017 15:38:14
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODArchivoSigep extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarArchivoSigep(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_archivo_sigep_sel';
		$this->transaccion='CONTA_ARCSGP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_archivo_sigep','int4');
		$this->captura('nombre_archivo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('url','varchar');
		$this->captura('extension','varchar');
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
			
	function insertarArchivoSigep(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_archivo_sigep_ime';
		$this->transaccion='CONTA_ARCSGP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('nombre_archivo','nombre_archivo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('url','url','varchar');
		$this->setParametro('extension','extension','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarArchivoSigep(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_archivo_sigep_ime';
		$this->transaccion='CONTA_ARCSGP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_archivo_sigep','id_archivo_sigep','int4');
		$this->setParametro('nombre_archivo','nombre_archivo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('url','url','varchar');
		$this->setParametro('extension','extension','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarArchivoSigep(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_archivo_sigep_ime';
		$this->transaccion='CONTA_ARCSGP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_archivo_sigep','id_archivo_sigep','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>