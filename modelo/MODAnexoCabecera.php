<?php
/**
*@package pXP
*@file gen-MODAnexoCabecera.php
*@author  (miguel.mamani)
*@date 21-08-2019 15:03:21
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAnexoCabecera extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAnexoCabecera(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_anexo_cabecera_sel';
		$this->transaccion='CONTA_AOA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_anexo_cabecera','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo','varchar');
		$this->captura('titulo','varchar');
		$this->captura('subtitulo','varchar');
		$this->captura('formula','varchar');
		$this->captura('id_reporte_anexos','int4');
		$this->captura('orden','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
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
			
	function insertarAnexoCabecera(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_anexo_cabecera_ime';
		$this->transaccion='CONTA_AOA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('titulo','titulo','varchar');
		$this->setParametro('subtitulo','subtitulo','varchar');
		$this->setParametro('formula','formula','varchar');
		$this->setParametro('id_reporte_anexos','id_reporte_anexos','int4');
		$this->setParametro('orden','orden','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAnexoCabecera(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_anexo_cabecera_ime';
		$this->transaccion='CONTA_AOA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_anexo_cabecera','id_anexo_cabecera','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('titulo','titulo','varchar');
		$this->setParametro('subtitulo','subtitulo','varchar');
		$this->setParametro('formula','formula','varchar');
		$this->setParametro('id_reporte_anexos','id_reporte_anexos','int4');
		$this->setParametro('orden','orden','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAnexoCabecera(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_anexo_cabecera_ime';
		$this->transaccion='CONTA_AOA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_anexo_cabecera','id_anexo_cabecera','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>