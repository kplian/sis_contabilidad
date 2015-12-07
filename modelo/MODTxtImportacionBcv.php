<?php
/**
*@package pXP
*@file gen-MODTxtImportacionBcv.php
*@author  (admin)
*@date 03-12-2015 16:57:22
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTxtImportacionBcv extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTxtImportacionBcv(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_txt_importacion_bcv_sel';
		$this->transaccion='CONTA_imptxt_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_txt_importacion_bcv','int4');
		$this->captura('nombre_archivo','varchar');
		$this->captura('id_periodo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
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
			
	function insertarTxtImportacionBcv(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_txt_importacion_bcv_ime';
		$this->transaccion='CONTA_imptxt_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('nombre_archivo','nombre_archivo','varchar');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTxtImportacionBcv(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_txt_importacion_bcv_ime';
		$this->transaccion='CONTA_imptxt_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_txt_importacion_bcv','id_txt_importacion_bcv','int4');
		$this->setParametro('nombre_archivo','nombre_archivo','varchar');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTxtImportacionBcv(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_txt_importacion_bcv_ime';
		$this->transaccion='CONTA_imptxt_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_txt_importacion_bcv','id_txt_importacion_bcv','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>