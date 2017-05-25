<?php
/**
*@package pXP
*@file gen-MODArchivoAirbp.php
*@author  (gsarmiento)
*@date 12-01-2017 21:44:52
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODArchivoAirbp extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarArchivoAirbp(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_archivo_airbp_sel';
		$this->transaccion='CONTA_AIRBP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_archivo_airbp','int4');
		$this->captura('nombre_archivo','varchar');
		$this->captura('anio','int4');
		$this->captura('mes','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
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
			
	function insertarArchivoAirbp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_archivo_airbp_ime';
		$this->transaccion='CONTA_AIRBP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('nombre_archivo','nombre_archivo','varchar');
		$this->setParametro('anio','anio','int4');
		$this->setParametro('mes','mes','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarArchivoAirbp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_archivo_airbp_ime';
		$this->transaccion='CONTA_AIRBP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_archivo_airbp','id_archivo_airbp','int4');
		$this->setParametro('nombre_archivo','nombre_archivo','varchar');
		$this->setParametro('anio','anio','int4');
		$this->setParametro('mes','mes','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarArchivoAirbp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_archivo_airbp_ime';
		$this->transaccion='CONTA_AIRBP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_archivo_airbp','id_archivo_airbp','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>